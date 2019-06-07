  Useful SLS commands:
  sls create
  sls create --template aws-java-gradle --path java-example
     - creates serverless.yml with options
  sls deploy -v
  sls deploy function -f hello
  sls invoke -f hello -l
  sls logs -f hello -t
  sls remove

YML NOTES:
    - ${self:XXX}
    - ${opt:XXXX}  sls cmd line option

Rest api example code:     https://github.com/serverless/examples

requirements.txt in python = package.json in node
