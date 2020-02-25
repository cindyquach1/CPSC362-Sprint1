import kivy
kivy.require('1.11.0')

from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
from kivy.uix.widget import Widget
from kivy.properties import ObjectProperty

class MyGridLayout(Widget):
    username = ObjectProperty(None)
    password = ObjectProperty(None)
        
    def btn(self):
        print("Name: ", self.username.text, "Email: ", self.password.text)
        self.username.text = ""
        self.password.text = ""

class MyApp(App):
    def build(self):
        return MyGridLayout()


if __name__ == '__main__':
    MyApp().run()