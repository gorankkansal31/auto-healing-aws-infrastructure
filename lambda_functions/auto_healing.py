import json
import boto3

def lambda_handler(event, context):
    print("Event received:", json.dumps(event))
    
    ec2_client = boto3.client('ec2')
    sns_client = boto3.client('sns')
    
    try:
        sns_message = event['Records'][0]['Sns']['Message']
        alarm_data = json.loads(sns_message)
        alarm_name = alarm_data.get('AlarmName', 'Unknown')
        new_state = alarm_data.get('NewStateValue', 'Unknown')
        
        print(f"Alarm: {alarm_name}, State: {new_state}")
        
        if new_state == 'ALARM' and 'unhealthy-host' in alarm_name:
            asg_name = "auto-healing-asg"
            
            asg_client = boto3.client('autoscaling')
            response = asg_client.describe_auto_scaling_groups(
                AutoScalingGroupNames=[asg_name]
            )
            
            instances = response['AutoScalingGroups'][0]['Instances']
            
            for instance in instances:
                if instance['HealthStatus'] != 'Healthy':
                    instance_id = instance['InstanceId']
                    print(f"Terminating unhealthy instance: {instance_id}")
                    
                    asg_client.terminate_instance_in_auto_scaling_group(
                        InstanceId=instance_id,
                        ShouldDecrementDesiredCapacity=False
                    )
        
    except (KeyError, IndexError, json.JSONDecodeError) as e:
        print(f"Error processing event: {e}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Auto-healing logic executed')
    }