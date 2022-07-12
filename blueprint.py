from pathlib import Path
from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2Instance, EC2AutoScaling
from diagrams.aws.devtools import Codedeploy
from diagrams.aws.general import User
from diagrams.aws.network import ALB
from diagrams.generic.os import Windows
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.vcs import Github


class ALBExample:

    def __init__(self):
        self.graph_attr = {
            "layout": "dot",
            "compound": "true",  # make edge can link cluster border
            "center": "true"
        }
        self.path = Path(__file__).parent.parent.joinpath("assets")

    def blueprint(self):
        with Diagram(
            name="CodeDeploy",
            filename=self.path.joinpath('codedeploy1').as_posix(),
            show=False,
            direction='LR',
            graph_attr=self.graph_attr
        ):
            windows = Windows("Github DeskTop")

            with Cluster('Github'):
                git = Github("Repo")
                git_action = GithubActions("CI/CD")
                git >> Edge(color="darkblue", label="Triggers") >> git_action

            code_deploy = Codedeploy("Codedeploy")

            windows >> Edge(color="darkblue", label="Commit&push") >> git
            git_action >> Edge(
                color="darkblue",
                label="Triggers") >> code_deploy

            with Cluster('ASG'):
                ec2s = [
                    EC2Instance("EC2Instance"),
                    EC2Instance("EC2Instance"),
                    EC2Instance("EC2Instance")]
                asg = EC2AutoScaling("EC2AutoScaling")
                asg >> Edge(color="darkblue", label="Roll update") >> ec2s

            code_deploy >> Edge(color="darkblue", label="Roll update") >> asg

            user = User("User")
            alb = ALB("ALB")
            user >> Edge(color="black", label="Visit") >> alb
            alb >> Edge(color="black", label="Forward") >> ec2s


if __name__ == '__main__':
    demo = ALBExample()
    demo.blueprint()
