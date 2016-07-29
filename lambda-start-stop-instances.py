import boto3
import logging

#setup simple logging for INFO
logger = logging.getLogger()
logger.setLevel(logging.INFO)

#define the connection
ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    # Use the filter() method of the instances collection to retrieve
    # all running EC2 instances.
    running_filters = [{
            'Name': 'tag:AutoOff',
            'Values': ['True']
        },
        {
            'Name': 'instance-state-name',
            'Values': ['running']
        }
    ]

    #filter the instances
    instances = ec2.instances.filter(Filters=running_filters)

    #locate all running instances
    RunningInstances = [instance.id for instance in instances]

    #print the instances for logging purposes
    #print RunningInstances 

    #make sure there are actually instances to shut down.
    if len(RunningInstances) > 0:
        #perform the shutdown
        shuttingDown = ec2.instances.filter(InstanceIds=RunningInstances).stop()
        print shuttingDown
    else:
        print "No instances matched the criterion"

    # Now start the instances that are in a stopped state with AutoOff tag
    stopped_filters = [{
            'Name': 'tag:AutoOff',
            'Values': ['True']
        },
        {
            'Name': 'instance-state-name',
            'Values': ['stopped']
        }
    ]

    #filter the instances
    instances = ec2.instances.filter(Filters=stopped_filters)

    #locate all Stopped instances
    StoppedInstances = [instance.id for instance in instances]

    #make sure there are actually instances to start.
    if len(StoppedInstances) > 0:
        startingUp = ec2.instances.filter(InstanceIds=StoppedInstances).start()
        print startingUp
    else:
        print "No instances matched the criterion"
