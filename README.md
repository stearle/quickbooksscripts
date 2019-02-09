# quickbooksscripts
utility scripts for quickbooks
there is only one script for now, but I suspect that more will be required


**verifyandsendiferror.ps1:**
---
Quickbooks does not have an email alert if the scheduled backup fails.  This can result in the data corruption not being caught until many days have passed, thereby creating a lot of manual work for the end user.  This script checks the backup log and sends an email to stake holders so they can revert to a very recent backup quickly, thereby saving them the headache of having to manually enter many days of work.

This script assumes you have some familiarity with powershell and execution policies

This is meant to be run on the database server, not workstation only systems.

I use <> to denote places where you must change the script except for the emailto addresses which are
a special case

A basic log file of ok and failed backups with timestamps is created to help you find out when your issues
started so you can recover quickly

I recommend setting up a separate drive or network location for your backups.

Once you have the script working you should create a new scheduled task to run this script shortly after your
scheduled Quickbooks backup.  That way you will have fast notice so you can stop your users from working and return to a good working copy of Quickbooks. 

I run my Quickbooks backups on an hourly basis by editing the task created in task scheduler so my users can recover from a data verification error quickly and have mininmal manual entries to catch up to.
If you do this you may find that you will have to keep quite a number of copies so you can recover from at least 3 or more days previously.  I have set my retained backups to the maximum of 99.  Your settings may vary.

