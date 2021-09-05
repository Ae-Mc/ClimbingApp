from django.http.request import QueryDict
from rest_framework.request import Request
from rest_framework.response import Response
from .serializers import (
    CategorySerializer,
    ImageSerializer,
    ImageReadSerializer,
    TrackReadSelializer,
    TrackSerializer,
    UserSerializer,
    GroupSerializer,
)
from .models import Category, Image, Track
from django.contrib.auth.models import User, Group
from rest_framework import status, viewsets
from rest_framework import permissions


class CategoryViewSet(viewsets.ModelViewSet):
    queryset = Category.objects.all()
    serializer_class = CategorySerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]


class ImageViewSet(viewsets.ModelViewSet):
    queryset = Image.objects.all()
    serializer_class = ImageReadSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]


class TrackViewSet(viewsets.ModelViewSet):
    queryset = Track.objects.all()
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def create(self, request: Request):
        data: dict
        if isinstance(request.data, QueryDict):
            data = dict(request.data.lists())
        else:
            return Response(
                ["Bad request format. Only allowed is multipart/form-data"],
                status=status.HTTP_400_BAD_REQUEST,
            )
        images = data.pop("images", [])
        trackSerializer = TrackSerializer(
            data={
                "name": data.get("name", [None])[0],
                "category": data.get("category", [None])[0],
                "description": data.get("description", [None])[0],
                "author": data.get("author", [None])[0],
                "uploader": data.get("uploader", [self.request.user.id])[0],
                "creationDate": data.get("creationDate", [None])[0],
            }
        )
        if not trackSerializer.is_valid():
            return Response(
                trackSerializer.errors, status=status.HTTP_400_BAD_REQUEST
            )

        saved = trackSerializer.save()
        trackID = saved.id
        imageSerializers = []
        for image in images:
            imageSerializers.append(
                ImageSerializer(data={"image": image, "track": trackID})
            )
            if not imageSerializers[-1].is_valid():
                Track.objects.filter(id=trackID).delete()
                return Response(
                    imageSerializers[-1].errors,
                    status=status.HTTP_400_BAD_REQUEST,
                )

        trackSerializer.save()
        for imageSerializer in imageSerializers:
            imageSerializer.save()
        return Response("OK", status=status.HTTP_201_CREATED)

    def get_serializer_class(self):
        if self.request.method in ["GET"]:
            return TrackReadSelializer
        return TrackSerializer


class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all().order_by("-date_joined")
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]


class GroupViewSet(viewsets.ModelViewSet):
    queryset = Group.objects.all()
    serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]
