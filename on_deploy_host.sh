# For deploying to production:
# 1. Install Virtualbox
# 2. Install Vagrant
# 3. Execute the following (can take about 9 minutes):
cd deploy-vm
vagrant up

# Additional steps for staging environment only:
# 4. Install Gitlab Runner
# 5. Execute the following:
gitlab-runner start
gitlab-runner unregister --all-runners
gitlab-runner register \
    --non-interactive \
    --url="https://gitlab.com/" \
    --registration-token="JW6YYWLG4mTsr_-mSaz8" \
    --executor="virtualbox" \
    --description="staging-vm" \
    --tag-list="virtualbox" \
    --virtualbox-base-name="bionic_lubuntu_vbox" \
    --virtualbox-disable-snapshots="false" \
    --ssh-user="vagrant" \
    --ssh-password="vagrant" \
    --ssh-identity-file="$PWD/.vagrant/machines/default/virtualbox/private_key"
gitlab-runner restart
gitlab-runner status
