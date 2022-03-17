import http from "k6/http";
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";

export default function () {
  let response = http.get("http://simple-http.default:80");
}

export function handleSummary(data) {
  console.log("Preparing the end-of-test summary...");

  if (!__ENV.REPORT_PRESIGNED_URL) {
    return;
  }
  const resp = http.put(__ENV.REPORT_PRESIGNED_URL, JSON.stringify(data), {
    headers: { "Content-Type": "application/json" },
  });

  if (resp.status != 200) {
    console.error("Could not send summary, got status " + resp.status);
  }

  const htmlRes = http.put(__ENV.REPORT_PRESIGNED_URL, htmlReport(data), {
    headers: { "Content-Type": "text/html" },
  });

  if (htmlRes.status != 200) {
    console.error("Could not send HTML summary, got status " + htmlRes.status);
  }
}

export const options = {
  scenarios: {
    constant_request_rate: {
      executor: "constant-arrival-rate",
      rate: 100,
      timeUnit: "1s", // 1000 iterations per second, i.e. 1000 RPS
      duration: "30s",
      preAllocatedVUs: 100, // how large the initial pool of VUs would be
      maxVUs: 200, // if the preAllocatedVUs are not enough, we can initialize more
    },
  },
};
