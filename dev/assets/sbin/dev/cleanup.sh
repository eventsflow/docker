#!/bin/sh

set -e


remove_cache_and_egg_files() {

    echo "[INFO] Cleaning cache files" && \
        find . -name __pycache__ -delete
    	# find . -name "__pycache__" -type d  -exec rm -rf {} \;

    echo "[INFO] Cleaning files: *.egg-info" && \
    	rm -rf "*.egg-info"
}


case ${1} in
    help)
        echo 'Available options:'
        echo ' help         - Displays the help'
        echo ' pre-clean    - Code cleanup before starting project testing or building'
        echo ' post-clean   - Code cleanup after starting project testing or building'
        ;;
    pre-cleanup)
        echo "[INFO] Starting pre-cleanup"
 
        remove_cache_and_egg_files
 
        echo "[INFO] Cleaning build directories" && \
        	rm -rf build dist

        echo "[INFO] Cleaning files: *.pyc" && \
        	find . -name "*.pyc" -delete

        ;;
    post-cleanup)
        echo "[INFO] Starting post-cleanup"
        
        remove_cache_and_egg_files

        echo "[INFO] Cleaning coverage files" && \
        	rm -rf \
        		.coverage.* 
        ;;
    *)
        if [ ! "$@" ]; then
            echo "[WARNING] No cleanup mode specified, use help for more details" 
        else
            exec "$@"
        fi
        ;;
esac 




