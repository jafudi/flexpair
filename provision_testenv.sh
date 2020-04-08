apt-get update

echo "\n\nInstall Python packages required for testing on guest OS..."
DEBIAN_FRONTEND=noninteractive apt-get install --upgrade -y --no-install-recommends python3-pip
pip3 install setuptools
pip3 install behave jsonschema tinydb invoke

mkdir -p builds
chmod --recursive 777 builds

rm -f .bash_logout

echo "\n\nInstall Gitlab Runnner for uploading artifacts from guest VM..."
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
dpkg -i gitlab-runner_amd64.deb
