# Centralized-Traffic-Inspection-with-AWSNetworkFirewall


![Centralized-Network-Inspection-with-AWSNetworkFirewall](https://github.com/user-attachments/assets/fc8075f0-4218-462e-8586-07d4f2222ca2)




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
