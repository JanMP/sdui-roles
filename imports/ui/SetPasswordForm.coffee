import React from 'react'
import {Accounts} from 'meteor/accounts-base'
import SimpleSchema from 'simpl-schema'
import SimpleSchemaBridge from 'uniforms-bridge-simple-schema-2'
import {AutoForm, SubmitField} from 'meteor/janmp:sdui-uniforms'

passwordSchema = new SimpleSchema
  password:
    type: String
    label: 'Passwort'
    # TODO: change regEx to accomodate sick desire for untripleclickselectable password
    regEx: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/

passwordSchemaBridge = new SimpleSchemaBridge passwordSchema

export default SetPasswordForm = ({token}) ->
  
  setPassword = ({password}) ->
    Auccounts.resetPassword token, password, (error) ->
      if error
        alert 'Fehler beim Zurücksetzen des Passworts: ' + error?.message

  <AutoForm
    schema={passwordSchema}
    submitField={-> <SubmitField value="Passwort setzen" />}
    onSubmit={setPassword}
  />