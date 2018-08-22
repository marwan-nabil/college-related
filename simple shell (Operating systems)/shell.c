#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>


int is_foreground=1;

void parse(char *line, char **argv)
// Parses the line array into a vector of arguments
{
    int inside_quotes=0;
	while(*line != '\0')
        {
//            if(*line=='\"')
//                inside_quotes=1;
//            else
            while(*line == ' ' || *line == '\t')
                // Replace separators by terminators
                {
                    *line = '\0';
                    line++;
                }
            if(*line=='\"')
                {
                    inside_quotes=1;
                    line++;
                }
            *argv = line;
            argv++;
            while(*line != ' ' && *line != '\t' && *line != '\0' ||inside_quotes)
            // Skip over the rest of the characters of the argument
                {
                    if (*line =='\n' && !inside_quotes)
                            *line = '\0';
                    if(*line=='\"')
                        {
                            *line='\0';
                            inside_quotes=0;
                        }
                    line++;
                }
        }
	*argv = '\0';
}

void check_bg(char **argv)
{
    if (strcmp(argv[(strlen((char*)argv)/4)-1],"&")==0)
        is_foreground=0;
}

void execute(char **argv)
// Forks a child process to run execvp
{
	pid_t pid;
	pid = fork();
	if(pid < 0)
	// Fork failed
        {
            printf("Error, no fork\n");
        }
	else if (pid==0)
	// In child process
        {
            execvp(argv[0], argv);
        }
    else if (pid != 0 && is_foreground==1)
	// In parent process and child is foreground
        {
            wait(NULL);
        }
    else
    // In parent and child is background
        printf("command is executing in background \n");

}


int main()
{
	char line[600]; // to accomodate for longer than 512 char input
	char *argv[128];
	while(1)
	{
        is_foreground=1;
		printf("> ");	// prompt for user input
		// get command and args from user and check for no command or too long arg list errors
		if(strlen(fgets(line, 600, stdin))==1)
			{
				printf("error :no command entered.\n");
				continue;
			}
		else if (strlen(line)>512)
            {
                printf("error: too long arguments list\n");
                continue;
            }
        // formats user inputs as a command entry followed by arg entries
		parse(line, argv);

        // checking for & and setting the flag
        check_bg(argv);

        // execution phase
		if(strcmp(argv[0], "cd") == 0)
		// An example of a shell built-in
			chdir(argv[1]);
		else
			execute(argv);
	}

	return 0;
}
