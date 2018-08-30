HADOOP SINGLE NODE CLUSTER SETUP FOR UBUNTU

NOTE: Do not run as executable script

# Adding a dedicated Hadoop system user
sudo addgroup hadoop
sudo adduser --ingroup hadoop hduser
sudo adduser hduser sudo


#Installing java
su - hduser
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer


#Check installation
java -version


# Configuring SSH
ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys


# Test Connection to localhost
ssh localhost


# Disable IPv6 (INSERT THE LINES BETWEEN THE STARS(*) AT THE END OF FILE)
sudo cp /etc/sysctl.conf /etc/sysctl.conf.backup
nano /etc/sysctl.conf
*
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
*
sudo sysctl -p


#Check IPv6 status, must be 1
cat /proc/sys/net/ipv6/conf/all/disable_ipv6


#Download hadoop (GET THE URL OF BINARY FILE FROM apache.org)
wget http://mirrors.wuchna.com/apachemirror/hadoop/common/hadoop-3.0.3/hadoop-3.0.3.tar.gz
tar xzf hadoop-3.0.3.tar.gz
sudo mv hadoop-3.0.3 /usr/local/hadoop
sudo chown -R hduser:hadoop /usr/local/hadoop


#Update bashrc (INSERT THE CODE BETWEEN THE STARS(*) IN THE END OF FILE)
nano .bashrc
*
# Set Hadoop-related environment variables
export HADOOP_HOME=/usr/local/hadoop
# Set JAVA_HOME 
export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
# Add Java bin
export PATH=$JAVA_HOME/bin:$PATH
# Add Hadoop bin/ directory to PATH
export PATH=$PATH:$HADOOP_HOME/bin
# Add Hadoop sbin/ directory to PATH
export PATH=$PATH:$HADOOP_HOME/sbin
*


#Update Hadoop ENV variables
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh


#Hadoop Configuration
sudo mkdir -p /app/hadoop/tmp
sudo chown -R hduser:hadoop /app/hadoop/tmp
sudo chmod -R 755 /app/hadoop/tmp


#Update core-site.xml (INSERT THE SNIPPETS BETWEEN THE STARS(*) IN BETWEEN <configuration> </configuration> TAG OF FILE)
nano /usr/local/hadoop/etc/hadoop/core-site.xml
*
<property>
  <name>hadoop.tmp.dir</name>
  <value>/app/hadoop/tmp</value>
  <description>A base for other temporary directories.</description>
</property>

<property>
  <name>fs.default.name</name>
  <value>hdfs://localhost:54310</value>
  <description>The name of the default file system.  A URI whose
  scheme and authority determine the FileSystem implementation.  The
  uri's scheme determines the config property (fs.SCHEME.impl) naming
  the FileSystem implementation class.  The uri's authority is used to
  determine the host, port, etc. for a filesystem.</description>
</property>
*


#Update mapred-site.xml (INSERT THE SNIPPETS BETWEEN THE STARS(*) IN BETWEEN <configuration> </configuration> TAG OF FILE)
nano /usr/local/hadoop/etc/hadoop/mapred-site.xml
*
<property>
  <name>mapred.job.tracker</name>
  <value>localhost:54311</value>
  <description>The host and port that the MapReduce job tracker runs
  at.  If "local", then jobs are run in-process as a single map
  and reduce task.
  </description>
</property>
*


#Update hdfs-site.xml (INSERT THE SNIPPETS BETWEEN THE STARS(*) IN BETWEEN <configuration> </configuration> TAG OF FILE)
nano /usr/local/hadoop/etc/hadoop/hdfs-site.xml
*
<property>
  <name>dfs.replication</name>
  <value>1</value>
  <description>Default block replication.
  The actual number of replications can be specified when the file is created.
  The default is used if replication is not specified in create time.
  </description>
</property>
*


#Test hadoop installation
hadoop namenode -format
start-all.sh
jps
sudo netstat -plten | grep java
stop-all.sh


#If datanode is not displayed in jps
sudo rm -rf /app/hadoop/tmp/*
sudo chmod -R 755 /app/hadoop/tmp/
hadoop namenode -format
start-all.sh
jps
stop-all.sh
