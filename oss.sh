#! /bin/bash
yes | python3 infra/helper.py build_image libpng
yes | python3 infra/helper.py build_fuzzers libpng
echo "Creating the output directories"
mkdir -p build/out/corpus{0..9}
echo "Launching the fuzzers"
pids=()
for i in {0..9};
do
        out=$(python3 infra/helper.py run_fuzzer libpng libpng_read_fuzzer --corpus-dir build/out/corpus$i  &> build/out/log$i & echo $!)
        pids+=($out)

done;
echo ${pids[@]}
echo "Fuzzers are running... Let's wait 24 hours now."
for i in {1..1440};
do
        sleep 1m
        echo "`date --rfc-3339=seconds` - has been running for $i minutes with `docker ps -q | wc -l` runners"
        for pidi in ${!pids[@]};do
                if  ! [ -d "/proc/${pids[$pidi]}" ]; then
                        out=$(python3 infra/helper.py run_fuzzer libpng libpng_read_fuzzer --corpus-dir build/out/corpus${pidi}  &>> build/out/log${pidi} & echo $!)
                        pids[${pidi}]=$out
                fi
        done
done
echo ${pids[@]}
docker stop `docker ps -q`

echo "Program completed. `docker ps -q | wc -l` containers are still running"
