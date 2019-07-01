# ProxyCommand helper for AWS EC2 Instance connect

Usage

```
.ssh/aws-proxy.sh [--profile profile] [--region region] [--key key] [--filter filterkey] user host [port]
```

Here `filterkey` is the name of the filter to the [DescribeInstances](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeInstances.html)
API call - it defaults to private-ip-address

e.g. if all your instances in the 10.1.0.0 subnet are in ap-southeast-2, you can use the following `~/.ssh/config`

```
Host 10.1.0.*
User ec2-user
ProxyCommand sh ~/.ssh/aws-proxy.sh --profile test-account --region ap-southeast-2 --key ~/.ssh/test-aws %r %h %p

Host ip-10-1-*
User ec2-user
ProxyCommand sh ~/.ssh/aws-proxy.sh --profile test-account --region ap-southeast-2 --filter private-dns-name --key ~/.ssh/test-aws %r %h %p
```
