

SECRETS_FOLDER=data/secret
TMP_DUMP_FOLDER=./tmp_dump


judge()
{
    mkdir -p $TMP_DUMP_FOLDER

    local passed=0
    local failed=0
    for file in "$SECRETS_FOLDER"/*.in; do
        local base=$(basename "$file" .in)
        python3 main.py  < "$file" > $TMP_DUMP_FOLDER/$base.out
        diff $TMP_DUMP_FOLDER/$base.out $SECRETS_FOLDER/$base.ans > /dev/null 
        if [ $? -eq 0 ]; then
            echo -e "\e[32mTest $base passed\e[0m"
            passed=$((passed+1))
        else
            echo -e "\e[31mTest $base failed\e[0m"
            failed=$((failed+1))
        fi
    done
    if [ $failed -eq 0 ]; then
        echo -e "\e[32mAll tests passed\e[0m"
    else
        echo -e "\e[31m$failed tests failed\e[0m"
    fi 

    rm -rf $TMP_DUMP_FOLDER
}

judge_all ()
{
    for folder in *; do
        if [ -d "$folder" ]; then
            (
                cd "$folder" || exit
                echo -e "\e[1m\e[34mJudging $folder\e[0m"
                judge
            )
        fi
    done

}


if [ $# -eq 0 ]; then
    judge_all
else
    if [ "$1" -eq "all" ]; then
        judge_all
    else
        if [ -d "$1" ]; then
            (
                cd "$1" || exit
                echo -e "\e[1m\e[34mJudging $1\e[0m"
                judge
            )
        else
            echo -e "\e[31m$1 is not a directory\e[0m"
        fi
    fi
fi

