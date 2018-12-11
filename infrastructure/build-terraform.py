from jinja2 import Environment, FileSystemLoader
import yaml

#Load YAML vars
dev_vars = yaml.load(open('./variables/developement.yml'))
#prod_vars = yaml.load(open('./variables/production.yml'))

#Load Jinja2 template
env = Environment(loader = FileSystemLoader('./templates'), trim_blocks=True, lstrip_blocks=True)
dev_template = env.get_template('developement.txt')
#prod_template = env.get_template('production.txt')

#Render the template/print the output
dev_terraform_file = dev_template.render(dev_vars)
print(dev_terraform_file)
#print(prod_template.render(prod_vars))

#Export generated tf file
with open("developement.tf", "wb") as fh:
    fh.write(dev_terraform_file)
