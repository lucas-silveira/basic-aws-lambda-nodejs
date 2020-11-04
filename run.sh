# 1º Criar arquivo de políticas de segurança
# 2º Criar role de segurança na AWS

aws iam create-role \
  --role-name lambda-example \
  --assume-role-policy-document file://policies.json \
  | tee logs/role.log

# 3º Criar arquivo com conteúdo e zipá-lo
zip function.zip index.js

# 4º Criar lambda fuction
aws lambda create-function \
  --function-name hello-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::012114261283:role/lambda-example \
  | tee logs/lambda-create.log

# 5º Invocar a lambda
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec.log

# 6º Depois de qualquer alteração na função, é preciso zipar e enviar novamente à AWS
zip function.zip index.js

aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-cli \
  --publish \
  | tee logs/lambda-update.log

# 7º Remover a lambda
aws lambda delete-function \
  --function-name hello-cli

# 8º Remover a role
aws iam delete-role \
  --role-name lambda-example