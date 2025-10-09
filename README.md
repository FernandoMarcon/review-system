# review-system


## run feed-n8n automatically 
```bash
chmod +x /home/fernando/utils/review-system/feed-n8n

# open crontab editor
crontab -e

# Add the Cron Job Line
0 6 * * * /home/fernando/utils/review-system/feed-n8n
```

