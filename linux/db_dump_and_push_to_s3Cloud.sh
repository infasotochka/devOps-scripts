set -euo pipefail


#DB Config
DB_NAME="..."


#S3 Config
S3_BUCKET="..."
S3_ENDPOINT="https://storage.yandexcloud.net"
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_DEFAULT_REGION="..."
BACKUP_DIR="/tmp"
DATE=$(date +'%Y-%m-%d')
FILE_NAME="db_backup_${DATE}.dump"
ARCHIVE_NAME="${FILE_NAME}.tar.gz"

echo "Делаю бэкап postgres..."

# Создание дампа и его сжатие
sudo -u postgres pg_dump -F c "$DB_NAME" > "$BACKUP_DIR/$FILE_NAME"
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" "$BACKUP_DIR/$FILE_NAME"

rm "$BACKUP_DIR/$FILE_NAME"

echo "Отправка в S3 Yandex Object storage"

aws --endpoint-url="$S3_ENDPOINT" s3 cp "$BACKUP_DIR/$ARCHIVE_NAME" "s3://$S3_BUCKET/backups/$ARCHIVE_NAME"

rm -f "$BACKUP_DIR/$ARCHIVE_NAME"

echo "Успешная загрузка бэкапа $ARCHIVE_NAME"
