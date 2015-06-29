#innobackupex用スクリプトファイル
MySQLのバックアップを取得するスクリプトです。
バックアップファイルはxbstream + pigzで直接圧縮形式で出力するので、ローカルディスクに無駄な領域は必要ありません。
* MySQLのバックアップをinnobackupexで取得します。
* 取得したバックアップをAWS S3にアップロードします。
* S3上のバックアップを削除します。

##Required
* s3cmd
* pigz

##Usage
スクリプト中の以下の部分を、利用環境に合わせて修正してください。
+ `BACKUP_DIR`
バックアップを一時保存するローカルディレクトリを指定します。
+ `S3_BUCKET`
バックアップファイルのアップロード先S3バケットを指定します。
+ `TAR_FILE`
バックアップファイル名を指定します。
S3上のファイルを名前順でソートして削除処理を行うため、ファイル名にバックアップ日時は入れておいたほうがよいです。
+ `innobackupex --user='root' --slave-info --stream=xbstream $BACKUP_DIR |  pigz > $BACKUP_DIR$TAR_FILE
`
バックアップ対象のDBに合わせてユーザやDB名を追加してください。
