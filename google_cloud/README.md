# PrivateIPしか持っていないDBにSQLを発行する
- Google Cloud
- DBはCloudSQL(PostgreSQL)
- 踏み台にパブリックIPを割り当てない
- [Identity-Aware Proxy](https://cloud.google.com/iap/docs/tcp-forwarding-overview?hl=ja)を使用して、TCP転送を行う

<!--
![connect-to-db](./connect-to-db.svg)
-->

# 実行コマンド
## ポートフォワーディング
### PowerShell
```
# 踏み台のインスタンス名
$bastion_instance_name='develop-hoge-bastion'

# 踏み台のインスタンスID
gcloud compute start-iap-tunnel ${bastion_instance_name} 5432 --local-host-port=localhost:15432 --zone=asia-northeast1-a
```

### コマンド実行後のコンソール
```
PS D:\repos\connect-to-private-rdb\google_cloud\terraform> $bastion_instance_name='develop-hoge-bastion'
PS D:\repos\connect-to-private-rdb\google_cloud\terraform>
PS D:\repos\connect-to-private-rdb\google_cloud\terraform> # 踏み台のインスタンスID
PS D:\repos\connect-to-private-rdb\google_cloud\terraform> gcloud compute start-iap-tunnel ${bastion_instance_name} 5432 --local-host-port=localhost:15432 --zone=asia-northeast1-a
WARNING:

To increase the performance of the tunnel, consider installing NumPy. For instructions,
please see https://cloud.google.com/iap/docs/using-tcp-forwarding#increasing_the_tcp_upload_bandwidth

Testing if tunnel connection works.
Listening on port [15432].
```
ローカルのポート15432が、踏み台のポート5432に転送される。