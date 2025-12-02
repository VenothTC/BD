### Permissions
`-rw-r--r--`: 4 groups of info: type(file or dir),
- `-` : denotes a file type, `d` directory, 
- `rw-` : user/owner of file, permission of creater
- `r--` : unix group file belongs to, other users 
- `r--`: others, evry1 not user or in group
Example:
- ```
	  chmod u+x script.sh
	  chmod g-w file.txt
	  chmod o-rwx secrets.txt
	  chmod g=r file.txt
	  chmod u=rw,g=r,o= file.txt
	  id # check ur uuid, gid, groups, 
  ```
`chmod 777 path/to/file.py` 
- `chmod u=rwx,g=rx,o=r file.txt` exact permissions
- 3 groups: u - user, g - group, o - owner, a - all(u,g,o)
- r - read(4), w - write(2), x - executable(1)
- **7** = rwx, (4+2+1), read write execute permission
- **6** = rw-, (4+2), read write only
- **5** = r-x, (1+4), read and execute only
- **4** = r--, (4), read only
- **0** = ---, no permissions



### Example Commands
1. `hadoop fs -ls` list directories
	- `-d` directories as plain files 
	-  `-h` see file sizes in human readable
	-  `-r` recursively list contents
2. `hadoop fs -mkdir UKUS18nov/venoth` create venoth directory in UKUS18nov 
3. `hadoop fs -cat` see contents of file
4. `hadoop fs -put <src-path-hdfs> <dst-path-hdfs>` upload local to  hdfs
   ```
   hadoop fs -put /local/data/ /hdfs/data/  # upload directory
   
   hadoop fs -put file1.txt file2.txt /user/hadoop/  # multiple files
   
   hadoop fs -put file1.txt file2.txt /user/hadoop/
   ```
	-  `-f` overwrite existing file if exists
	- `-p` create parent directory if does not exist, perserve timestamp, permissions, ownership
	- `-u` upload file only if dst is older
 5. `hadoop fs -copyFromLocal <src> <dst> ` copy from local to hdfs
 6. `hadoop fs -copyToLocal <src-hadoop-path> <dst-local-path>` from hdfs to local fs
 7. `hadoop fs -get <src-hadoop> <dst-local>` - from hdfs to local
 8. `hadoop fs -rm /path/to/file.txt`
	 - `hadoop fs -rm UKUS18nov/venoth/*.txt` delete all txt files
	 - `-r` can add to delete a directory and its contents recursively 
9. `hadoop -cp <src-path> <dest-path>` copy file within HDFS
10. `hadoop fs -mv <src-path> <dest-path>` move file within HDFS
11. `hadoop fs -du UKUS18nov/venoth/a_hello.txt` - disk usage of file
12. `hadoop fs -appendToFile <local-path1> <local-path2> ... <dest-hdfs-path>` appends all contents of local files into destination file path.
	1. `hadoop fs -appendToFile /home/ec2-user/18nov/venoth/a_hello.txt /home/ec2-user/18nov/venoth/b.txt UKUS18nov/venoth/appended/appended.txt
13. `hadoop fs -tail UKUS18nov/venoth/a_hello.txt` shows last 1kb of contents in file in HDFS
14. `hadoop fs -touchz UKUS18nov/venoth/empty.txt` create empty file in HDFS
15. `hadoop fs -setrep <replication-factor #> <hdfs/file/to/path>` 
	- `hadoop fs -setrep 4 UKUS18nov/venoth/a_hello.txt` 
	- `-w` comand exec wait for replication to complete 
	- `-R` applies replication to directoires and sub directories recursively
16. `hadoop fs -getmerge -nl UKUS18nov/venoth venoth/merged.txt` merge all files in direcotry and make new line after evry file appended
17. `hadoop fs -count UKUS18nov/venoth` count # directories, files in bytes
18. `hadoop fs -chmod 777 UKUS18nov/venoth/a_hello.txt` give all permissions to a_hello.txt file
19. `hadoop fs -chgrp ec2-user UKUS18nov/venoth/a_hello.txt` change file to ec2-user group
20. `hadoop fs -chown ec2-user:ec2-user UKUS18nov/venoth/a_hello.txt` change user and group id for a_hello.txt
