# Generated by Django 4.2 on 2023-11-30 06:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('feed', '0005_alter_feed_user_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='feed',
            name='post_date',
            field=models.DateTimeField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='feed',
            name='post_id',
            field=models.BigAutoField(primary_key=True, serialize=False),
        ),
    ]
