from django import forms

from imagetagger.images.models import ImageSet


class ImageSetCreationForm(forms.ModelForm):
    class Meta:
        model = ImageSet
        fields = [
            'name',
            'location',
            'public',
            'public_collaboration',
            'assignee',
            'folder'
        ]


class ImageSetCreationFormWT(forms.ModelForm):
    class Meta:
        model = ImageSet
        fields = [
            'name',
            'location',
            'public',
            'public_collaboration',
            'team',
            'assignee',
            'folder'
        ]


class ImageSetEditForm(forms.ModelForm):
    class Meta:
        model = ImageSet
        fields = [
            'name',
            'assignee',
            'folder',
            'location',
            'description',
            'public',
            'public_collaboration',
            'image_lock',
            'priority',
            'main_annotation_type',
        ]


class LabelUploadForm(forms.Form):
    file = forms.FileField()
    verify = forms.BooleanField(required=None)
