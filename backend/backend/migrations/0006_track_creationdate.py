# Generated by Django 3.2.4 on 2021-07-15 20:30

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('backend', '0005_alter_image_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='track',
            name='creationDate',
            field=models.DateField(default=django.utils.timezone.now),
        ),
    ]
