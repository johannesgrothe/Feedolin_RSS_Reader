import sys, re

#Regex
commit_msg_pattern = "^#[0-9]+ "
branch_pattern = "^fb_[0-9]+_"

branch_name = sys.argv[2]

if branch_name == "develop" or branch_name == "master":
	# Don't check merge messages
	sys.exit(0)

#Get the commit file
commit_message_file = open(sys.argv[1]) #The first argument is the file
commit_message = commit_message_file.read().strip()

issue_nr = None
branch_nr = None

try:
	issue_nr = re.findall(commit_msg_pattern, commit_message)[0]
except IndexError as e:
	print("The commit-message needs to start with a issue number")
	sys.exit(1)
	
try: 
	branch_nr = re.findall(branch_pattern, branch_name)[0]
except IndexError as e:
	print("The branch you're trying to commit to does not fit the repository naming convention.")
	sys.exit(1)
	
issue_nr = issue_nr[1:-1]
branch_nr = branch_nr[3:-1]

if issue_nr != branch_nr:
	print("Issue-numbers from commit-messsage and branch have to match".format(issue_nr, branch_nr))
	sys.exit(1)
	
sys.exit(0)