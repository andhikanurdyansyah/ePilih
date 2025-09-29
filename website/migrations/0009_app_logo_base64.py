# Generated manually

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('website', '0008_auto_20230111_1556'),
    ]

    operations = [
        migrations.AddField(
            model_name='app',
            name='app_logo_base64',
            field=models.TextField(blank=True, null=True),
        ),
    ]
