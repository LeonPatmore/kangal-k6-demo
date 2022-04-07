import http from "k6/http";
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import sqs from "k6/x/sqs";

const client = sqs.newClient();

export default function () {
  const params = {
    DelaySeconds: 0,
    MessageAttributes: {
      Title: {
        DataType: "String",
        StringValue: "The Whistler",
      },
      Author: {
        DataType: "String",
        StringValue: "John Grisham",
      },
      WeeksOn: {
        DataType: "Number",
        StringValue: "6",
      },
    },
    MessageBody:
      "Information about current NY Times fiction bestseller for week of 12/11/2016.",
    // MessageDeduplicationId: "TheWhistler",  // Required for FIFO queues
    // MessageGroupId: "Group1",  // Required for FIFO queues
    QueueUrl: "QUEUE_URL",
  };

  sqs.send(client, params);
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
