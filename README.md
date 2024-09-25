# Centralized-Traffic-Inspection-with-AWSNetworkFirewall


![Centralized-Network-Inspection-with-AWSNetworkFirewall](https://github.com/user-attachments/assets/fc8075f0-4218-462e-8586-07d4f2222ca2)


## Key Components 
- 2x EC2 instances
- If you don't have IAM instance profile, create one with this AWS Managed Policy : AmazonSSMManagedInstanceCore . And attach the role to Ec2 instances (Mine is SSM-for-ec2)
- VPC-A , 1x Private Subnet in us-east-1a
- VPC-B , 1x Private Subnet in us-east-1b
- Security-VPC, IGW, 2x NAT Gateway, 2x Firewall Subnets in different AZs, 2x TGW subnets in different AZs, 2x public subnets in different AZs
- 2x Firewall RTB, 2x TGW Subnet RTB, 2x Public Subnet RTB, RTB for Private Subnet-A , RTB for Private Subnet-B
- AWS Network Firewall, Firewall Policy, Firewall Rule Group
- 1x Transit Gateway , 3x Transit Gateway Attachment , 2x Transit Gateway Route Tables


## Goals
- Direct all the incoming traffic to AWS Network Firewall to be inspected. (For North-South Traffic)
- Direct all the traffic between Server-A and Server-B to go through AWS Network Firewall to be inspected. (For East-West Traffic)

## Verify the traffic flow using AWS Network Firewall Rule Group
- Add a network firewall rule to block traffic between Server-A and B to verify that the traffic is actually going through Network Firewall. (For East-West Traffic)
- EC2 instances must have internet access. (For North-South Traffic)


#### If you are wondering how I describe Gateway Load Blancer Endpoint ID , check below. Let's explore step by step.

Step 1: 
```bash
aws_networkfirewall_firewall.network_firewall.firewall_status[0]

Output: 

{
  "sync_states" = toset([
    {
      "attachment" = tolist([
        {
          "endpoint_id" = "vpce-01b36bb3d8403f411"
          "subnet_id" = "subnet-058437099ab09013b"
        },
      ])
      "availability_zone" = "us-east-1a"
    },
    {
      "attachment" = tolist([
        {
          "endpoint_id" = "vpce-0fc02d0b9e40c27e5"
          "subnet_id" = "subnet-0de639a0eeac4e394"
        },
      ])
      "availability_zone" = "us-east-1b"
    },
  ])
}
```

Step 2:
```bash
aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*]

Output: 

tolist([
  {
    "attachment" = tolist([
      {
        "endpoint_id" = "vpce-01b36bb3d8403f411"
        "subnet_id" = "subnet-058437099ab09013b"
      },
    ])
    "availability_zone" = "us-east-1a"
  },
  {
    "attachment" = tolist([
      {
        "endpoint_id" = "vpce-0fc02d0b9e40c27e5"
        "subnet_id" = "subnet-0de639a0eeac4e394"
      },
    ])
    "availability_zone" = "us-east-1b"
  },
])
```

Step 3:

```bash
aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0]

Output: 

tolist([
  {
    "endpoint_id" = "vpce-01b36bb3d8403f411"
    "subnet_id" = "subnet-058437099ab09013b"
  },
  {
    "endpoint_id" = "vpce-0fc02d0b9e40c27e5"
    "subnet_id" = "subnet-0de639a0eeac4e394"
  },
])

```

Step 4:

```bash
aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id

Output: 

tolist([
  "vpce-01b36bb3d8403f411",
  "vpce-0fc02d0b9e40c27e5",
])
```

Final:

```bash
(aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]

Output: 

"vpce-01b36bb3d8403f411"


(aws_networkfirewall_firewall.network_firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[1]

Output: 

"vpce-0fc02d0b9e40c27e5"

```
