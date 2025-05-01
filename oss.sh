#! /bin/bash
yes | python3 infra/helper.py build_image libpng
yes | python3 infra/helper.py build_fuzzers libpng
echo "Creating the output directories"
mkdir -p build/out/corpus{1..10}
echo "Launching the fuzzers"
for i in {1..10};
do
        python3 infra/helper.py run_fuzzer libpng libpng_read_fuzzer --corpus-dir build/out/corpus$i > build/out/log$1 2>&1 &
done;
echo "Fuzzers are running... Let's wait 24 hours now."
for i in {1..24};
do
        sleep 1h
        echo "`date --rfc-3339=seconds` - has been running for $i hours with `docker ps -q | wc -l` runners"
done
docker stop `docker ps -q`

echo "Program completed. `docker ps -q | wc -l` containers are still running"
