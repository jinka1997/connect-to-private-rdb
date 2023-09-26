# PrivateIPしか持っていないDBにSQLを発行する
- AWS
- DBはAurora(PostgreSQL)
- 踏み台はプライベートサブネットに置く
- セッションマネージャーでプライベートサブネットの踏み台に接続する

![connect-to-db](./connect-to-db.svg)

# 実行コマンド
## トークン取得
### PowerShell
Terraform実行するときに使用
```
$aws_account_id='999999999999' # AWSのアカウントID
$iam_user='xxxxxxxxx'          # IAMユーザ名
$mfa_token='999999'            # MFAデバイスでから取得したトークン
$mfa_device="arn:aws:iam::${aws_account_id}:mfa/${iam_user}"

$cre=(aws sts get-session-token --serial-number ${mfa_device} --token-code ${mfa_token}) | ConvertFrom-Json
$Env:AWS_ACCESS_KEY_ID=$cre.Credentials.AccessKeyId
$Env:AWS_SECRET_ACCESS_KEY=$cre.Credentials.SecretAccessKey
$Env:AWS_SESSION_TOKEN=$cre.Credentials.SessionToken
```

### Git Bash
ポートフォワーディングする時に使用
```
aws_account_id='999999999999' # AWSのアカウントID
iam_user='xxxxxxxxx'          # IAMユーザ名
mfa_token='999999'            # MFAデバイスでから取得したトークン
mfa_device="arn:aws:iam::${aws_account_id}:mfa/${iam_user}"
cre=$(aws sts get-session-token --serial-number ${mfa_device} --token-code ${mfa_token})
export AWS_ACCESS_KEY_ID=$(echo $cre | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $cre | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $cre | jq -r '.Credentials.SessionToken')
```


## ポートフォワーディング
### git bash
```
# 踏み台のインスタンス名
bastion_instance_name='develop-bastion'

# Auroraのクラスター識別子
aurora_cluster_identifier='develop-hoge-cluster'

# 踏み台のインスタンスID
bastion_instance_id=$(aws ec2 describe-instances --filters Name='tag:Name',Values=${bastion_instance_name} --query Reservations[0].Instances[0].InstanceId --output text)

# ローカルの15432を、サーバの5432に転送
param='{"host":["'
param+=$(aws rds describe-db-cluster-endpoints --db-cluster-identifier ${aurora_cluster_identifier} --filters "Name='db-cluster-endpoint-type',Values='writer'" --query DBClusterEndpoints[].Endpoint --output text)
param+='"],"portNumber":["5432"],"localPortNumber":["15432"]}'

aws ssm start-session --target ${bastion_instance_id} \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters ${param}
```