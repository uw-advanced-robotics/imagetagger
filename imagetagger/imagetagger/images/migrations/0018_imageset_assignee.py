# Generated by Django 2.0.13 on 2019-11-09 22:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('images', '0017_imageset_zip_state'),
    ]

    operations = [
        migrations.AddField(
            model_name='imageset',
            name='assignee',
            field=models.CharField(default='', max_length=100),
        ),
    ]
