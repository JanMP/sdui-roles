import {Meteor} from 'meteor/meteor'
import {Accounts} from 'meteor/accounts-base'
import React, {useState} from 'react'
import SimpleSchema from 'simpl-schema'
import SimpleSchemaBridge from 'uniforms-bridge-simple-schema-2'
import {AutoForm, SubmitField} from 'meteor/janmp:sdui-uniforms'


SimpleSchema.extendOptions(['uniforms'])

loginSchema = new SimpleSchema
  email:
    type: String,
    label: 'E-Mail'
  password: 
    type: String,
    label: 'Passwort'
    uniforms: 
      type: 'password'

signupSchema = new SimpleSchema
  email:
    type: String
    label: 'E-Mail'
    regEx: SimpleSchema.RegEx.EmailWithTLD
  username:
    type: String
    label: 'Benutzername'
    min: 3
    max: 80
  password:
    type: String
    label: 'Passwort'
    # TODO: change regEx to accomodate sick desire for untripleclickselectable password
    regEx: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/
    max: 80
    uniforms:
      type: 'password'
  passwordRepeat:
    type: String
    label: 'Password wdh.'
    custom: ->
      if @value isnt @field('password').value then 'password mismatch'
    uniforms:
      type: 'password'

emailSchema = new SimpleSchema
  email:
    type: String
    label: 'E-Mail'
    regEx: SimpleSchema.RegEx.EmailWithTLD

loginSchemaBridge = new SimpleSchemaBridge loginSchema
signupSchemaBridge = new SimpleSchemaBridge signupSchema
emailSchemaBridge = new SimpleSchemaBridge emailSchema


loginForm = ->
  login = ({email, password}) ->
    Meteor.loginWithPassword email, password, (error) ->
      if error
        alert 'Login fehlgeschlagen: ' + error
 
  <AutoForm
    schema={loginSchemaBridge}
    submitField={-> <SubmitField value="Login" />}
    onSubmit={login}
  />


signupForm = ->
  signup = (model) ->
    Accounts.createUser model, (error) ->
      if error
        alert 'User Account konnte nicht angelegt werden: ' + error?.message

  <AutoForm
    schema={signupSchemaBridge}
    submitField={-> <SubmitField value="Account anlegen" />}
    onSubmit={signup}
  />

emailForm = ->
  resetPassword = (model) -> console.log model

  <AutoForm
    schema={emailSchemaBridge}
    submitField={-> <SubmitField value="Password zurücksetzen" />}
    onSubmit={resetPassword}
  />

export default LoginForm = ->
  [formToShow, setFormToShow] = useState 'login'

  [Form, loginOrSignupLabel] = switch formToShow
    when 'login' then [loginForm, 'Ich habe noch keinen Account']
    when 'signup' then [signupForm, 'Ich habe bereits einen Account']
    when 'resetPassword' then [emailForm, 'Ich habe noch keinen Account']
    else [null, 'fnord']

  toggleLoginOrSignup = ->
    if formToShow is 'signup' then setFormToShow 'login' else setFormToShow 'signup'
  

  <div>
    <Form />
    { <div>
      <a onClick={-> setFormToShow 'resetPassword'}>Ich habe mein Passwort vergessen</a>
    </div> if formToShow isnt 'resetPassword'}
    {<div>
      <a onClick={toggleLoginOrSignup}>{loginOrSignupLabel}</a>
    </div> if loginOrSignupLabel?}
  </div>