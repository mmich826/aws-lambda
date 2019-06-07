'use strict';

let AWS = require('aws-sdk');
AWS.config.update({region: 'us-east-1'});

let ecs = new AWS.ECS();


module.exports.handler = (event, context, callback) => {
  let params = {
    cluster: "inv-pipe-s3-pilot",
    taskDefinition: "inv-pipe-s3-pilot:6",
    launchType: "FARGATE",
    networkConfiguration: {
      awsvpcConfiguration: {
        subnets: [
          "subnet-5eab6a06"
        ]
      }
    }
  };

  let resp;
  ecs.runTask(params, function(err, data) {
    if (err) console.log(err, err.stack); // an error occurred
    else {
      resp = data
      console.log(data);
    }           // successful response
  });
  // ecs.listTaskDefinitions(params, function (err, data) {
  //   console.log(data);
  // })
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: resp,
      input: event,
    }),
  };

  callback(null, response);

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // callback(null, { message: 'Go Serverless v1.0! Your function executed successfully!', event });
};
