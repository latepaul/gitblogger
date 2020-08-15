#    Welcome to 'gitblogger' the git-based micro-blogger
 
OK, this is pointless. There are much better ways to blog. There's even ways
to blog using git. You may be interested in https://github.com/rsms/gitblog
for example. 

gitblogger is a tool that creates a blog where each post is the commit message
in a git update. It updates a file called FILE which contains a line with the
current post number. 

To setup:
 
1. Create an empty git repo somewhere, e.g. github
2. Clone the repo to your local machine
3. Copy gitblogger.sh to the directory and git add it. Do not commit yet. 

To post:

- sh gitblogger.sh and enter your thoughts into the commit message. When you save it it will be committed and pushed to the central repo. 
- gitblogger.sh is added automatically with each commit. So if you update it any changes will get saved in the next 'post'. The idea is not to 'pollute' your blog with commits purely for code changes. 

To read:

- if you're on a machine you've not used before then you can clone the repo. It needs to be able to run a simple bash script. Linux is great. WSL bash is fine. Then all you need is...
- git log     
- or 'sh readblog.sh' - main reason I added this was so you could read in reverse order (earliest first)
- or if your central repo has a web interface, e.g. github, you could use that. For me personally that gets away from the minimalism that gitblogger is all about.

That's it (told you it was pointless!)
