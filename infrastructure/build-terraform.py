#!/usr/bin/python
from jinja2 import Environment, FileSystemLoader
import yaml, sys, getopt

def main(argv):
    input_env_file = ''
    output_env_file = ''
    help_message = """
USAGE: python build-terraform.py -i <env-vars.yml> -e <env-template.txt> -o <env-configuration.tf>

This command allow you to create a terraform configuration file on AWS inside a VPC.It is based on a jinja template and a YAML file for EC2 variables configuration.

You have to insert:
- valid YAML environnement vars file (INPUT) [in variables directory]
- valid Jinja terraform template file (INPUT) [in templates directory]
- valid terraform environennement file (OUTPUT)

Exemple:
- Basic Usage:

    python build-terraform.py -i env-production.yml -e env-production.txt -o env-production.tf

- For help:

    python build-terraform.py -h
    """
    terraform_template_dir_location = Environment(loader = FileSystemLoader('./templates'), trim_blocks=True, lstrip_blocks=True)

    try:
        opts, args = getopt.getopt(argv,"hi:e:o:",["input-vars=","environnement-template=","outputfil="])
    except getopt.GetoptError:
        print help_message
        sys.exit(2)
    #if some arguments
    for opt, arg in opts:
        if opt == '-h':
            print help_message
            sys.exit()
        elif opt in ("-i", "--input-vars"):
            input_vars_file_name = arg
            env_vars_file = yaml.load(open('./variables/%s' % input_vars_file_name))
        elif opt in ("-e", "--environnement-template"):
            input_template_file_name = arg
            env_template_file = terraform_template_dir_location.get_template('%s' % input_template_file_name)
        elif opt in ("-o", "--output-terraform-file"):
            output_terraform_file_name = arg
            env_terraform_file = env_template_file.render(env_vars_file)
            print(env_terraform_file)
            #Render template in a terraform file
            with open("./tf_files/%s" % output_terraform_file_name, "wb") as fh:
                fh.write(env_terraform_file)

if __name__ == "__main__":
    #Pass to main function the first to len(sys.argv) parameter
    main(sys.argv[1:])
