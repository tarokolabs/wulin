from minio import Minio
from minio.error import S3Error
def main():
    client = Minio(
        "minio.s3:9000",
        secure=False, access_key="minio", secret_key="minio123"
    )
    found = client.bucket_exists("mypy")
    if not found:
        client.make_bucket("mypy")
        print("Created bucket", "mypy")
    else:
        print("Bucket mypy already exists")

if __name__ == "__main__":
    try:
        main()
    except S3Error as exc:
        print("error occurred.", exc) 
