#!/bin/bash

#nb: must be bash to support shopt globstar
set -e
shopt -s globstar

if [ "$BUILD_TOOLS" = false ]; then
	if grep '"aaa" = \(.+\)' _maps/**/*.dmm;	then
    	echo "Non-TGM formatted map detected. Please convert it using Map Merger!"
    	exit 1
	fi;
	if grep 'step_[xy]' _maps/**/*.dmm;	then
    	echo "step_[xy] variables detected in maps, please remove them."
    	exit 1
	fi;
	if grep 'pixel_[xy] = 0' _maps/**/*.dmm;	then
    	echo "pixel_[xy] = 0 detected in maps, please review to ensure they are not dirty varedits."
	fi;
	if grep '\td[1-2] =' _maps/**/*.dmm;	then
    	echo "d[1-2] cable variables detected in maps, please remove them."
    	exit 1
	fi;
	if grep '^/area/.+[\{]' _maps/**/*.dmm;	then
    	echo "Vareditted /area path use detected in maps, please replace with proper paths."
    	exit 1
	fi;
	if grep '\W\/turf\s*[,\){]' _maps/**/*.dmm; then
    	echo "base /turf path use detected in maps, please replace with proper paths."
    	exit 1
	fi;
	if grep '^/*var/' code/**/*.dm; then
		echo "Unmanaged global var use detected in code, please use the helpers."
		exit 1
	fi;
	if grep -i 'centcomm' code/**/*.dm; then
		echo "Misspelling(s) of CENTCOM detected in code, please remove the extra M(s)."
		exit 1
	fi;
	if grep -i 'centcomm' _maps/**/*.dmm; then
		echo "Misspelling(s) of CENTCOM detected in maps, please remove the extra M(s)."
		exit 1
	fi;

    source $HOME/BYOND/byond/bin/byondsetup
	if [ "$BUILD_TESTING" = true ]; then
		tools/travis/dm.sh -DTRAVISBUILDING -DTRAVISTESTING -DALL_MAPS yogstation.dme
	else
		tools/travis/dm.sh -DTRAVISBUILDING yogstation.dme
		
		tools/deploy.sh travis_test
		mkdir travis_test/config

		#test config
<<<<<<< HEAD
		cp tools/travis/travis_config.txt config/config.txt
=======
		cp tools/travis/travis_config.txt travis_test/config/config.txt
>>>>>>> c20be496a8... Adds deploy script. CI artifacts. Dependencies file (#39040)

		# get libmariadb, cache it so limmex doesn't get angery
		if [ -f $HOME/libmariadb ]; then
			#travis likes to interpret the cache command as it being a file for some reason
			rm $HOME/libmariadb
<<<<<<< HEAD
			mkdir $HOME/libmariadb
		fi
=======
		fi
		mkdir -p $HOME/libmariadb
>>>>>>> c20be496a8... Adds deploy script. CI artifacts. Dependencies file (#39040)
		if [ ! -f $HOME/libmariadb/libmariadb.so ]; then
			wget http://www.byond.com/download/db/mariadb_client-2.0.0-linux.tgz
			tar -xvf mariadb_client-2.0.0-linux.tgz
			mv mariadb_client-2.0.0-linux/libmariadb.so $HOME/libmariadb/libmariadb.so
			rm -rf mariadb_client-2.0.0-linux.tgz mariadb_client-2.0.0-linux
		fi
<<<<<<< HEAD
    	ln -s $HOME/libmariadb/libmariadb.so libmariadb.so
	
		DreamDaemon yogstation.dmb -close -trusted -verbose -params "test-run&log-directory=travis"
		cat data/logs/travis/clean_run.lk
=======
	
		cd travis_test
    	ln -s $HOME/libmariadb/libmariadb.so libmariadb.so
		DreamDaemon tgstation.dmb -close -trusted -verbose -params "test-run&log-directory=travis"
		cd ..
		cat travis_test/data/logs/travis/clean_run.lk

>>>>>>> c20be496a8... Adds deploy script. CI artifacts. Dependencies file (#39040)
	fi;
fi;
