import http from "k6/http";

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
}
