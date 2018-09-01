RUNNING BASIC MAPREDUCE PROGRAM ON HADOOP

NOTE: Do not run as executable script

#create text file on hduser
nano /tmp/gutenberg/pg20417.txt
nano /tmp/gutenberg/pg4300.txt
nano /tmp/gutenberg/pg5000.txt

#Create Directory in hdfs
hdfs dfs -mkdir -p /user/hduser

#Copy local files to hadoop
hadoop dfs -copyFromLocal /tmp/gutenberg /user/hduser/gutenberg

#Listing the files on hadoop
hadoop dfs -ls /user/hduser/gutenberg

#Running the map reducer present in "/usr/local/hadoop/share/hadoop/mapreduce"
cd /usr/local/hadoop/share/hadoop/mapreduce
hadoop jar hadoop*examples*.jar wordcount /user/hduser/gutenberg /user/hduser/gutenberg-output

#Retrieving the job result
hadoop dfs -cat /user/hduser/gutenberg-output/part-r-00000

