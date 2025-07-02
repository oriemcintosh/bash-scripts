# How to Enable Docker Bash Completion

1. Run script `docker-bash-completion.sh`
2. Source bash file to trigger refresh for bash_completion
  
    a. The script should include something like this like this:

    ```sh
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
    ```

    b. Source shell configuration command:
    
    ```sh
    source ~/.bashrc
    ````

3. Make or ensure the bash-completions folder is present:
    ```sh
    mkdir -p ~/.local/share/bash-completion/completions
    ```

4. Run the completion command for bash and send the output to the docker directory:
    ```sh
    docker completion bash > ~/.local/share/bash-completion/completions/docker
    ```