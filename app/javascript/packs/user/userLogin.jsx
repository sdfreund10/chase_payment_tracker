import React from 'react'
import PropTypes from 'prop-types'
import Input from './input'

export default class UserLogin extends React.Component {
  constructor(props){
    super(props);

    this.state = { logIn: true, form: {} };
  }

  formBuilder () {
    if (this.state.logIn) {
      return(
        <form>
          <h1>Log In</h1>
          <Input placeholder='Email' value={this.state.form.email}
                 handler={this.handleFormChange.bind(this)}/>
          <Input placeholder='Password' value={this.state.form.password}
                 handler={this.handleFormChange.bind(this)}/>
        </form>
      )
    } else {
      return(
        <form>
          <h1 className='form-control'>Sign Up</h1>
          <Input placeholder='Name' value={this.state.form.name}
                 handler={this.handleFormChange.bind(this)}/>
          <Input placeholder='Email' value={this.state.form.email}
                 handler={this.handleFormChange.bind(this)}/>
          <Input placeholder='Password' value={this.state.form.password}
                 handler={this.handleFormChange.bind(this)}/>
          <Input placeholder='Password Confirmation' value={this.state.form.passwordConfirm}
                 handler={this.handleFormChange.bind(this)}/>
        </form>
      )
    }
  }

  logInToggleButton () {
    if (this.state.logIn) {
      return(
        <button className='btn btn-default' onClick={this.toggleLogIn.bind(this)}>
          Sign Up
        </button>
      )
    } else {
      return(
        <button className='btn btn-default' onClick={this.toggleLogIn.bind(this)}>
          Log In
        </button>
      )
    }
  }

  logIn () {
    this.props.setUser({name: "Existing User"})
  }

  signUp () {
    this.props.setUser({name: "New User"})
  }

  toggleLogIn () {
    this.setState({logIn: !this.state.logIn});
  }

  handleFormChange (updateObject) {
    this.setState(updateObject)
  }

  render () {
    return (
      <div className='form'>
        {this.formBuilder()}
        <button className='btn btn-default'
                onClick={this.state.logIn ? this.logIn.bind(this) : this.signUp.bind(this)}>
          Submit
        </button>
        {this.logInToggleButton()}
      </div>
    );
  }
}