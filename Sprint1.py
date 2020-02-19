import kivy
kivy.require('1.11.0')

from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button

class MyGridLayout(GridLayout):
    def __init__(self, **kwargs):
        super(MyGridLayout, self).__init__(**kwargs)
        self.cols = 2
        self.add_widget(Label(text="Username"))
        self.name = TextInput(multiline=False)
        self.add_widget(self.name)

        self.add_widget(Label(text="Password"))
        self.password = TextInput(multiline=False)
        self.add_widget(self.password)

        self.createAcc = Button(text="Create Account", font_size=40)
        self.add_widget(self.createAcc)

        self.login = Button(text="Login", font_size=40)
        self.add_widget(self.login)

class MyApp(App):

    def build(self):
        return MyGridLayout()


if __name__ == '__main__':
    MyApp().run()

