import React from 'react'
import PropTypes from 'prop-types'

export default class UserLogin extends React.Component {
  constructor(props){
     super(props);

     this.state = { logIn: true };
  }

  formBuilder () {
    if (this.state.logIn) {
      return(
        <form>
          <h1>Log In</h1>
          <input type='text' placeholder='Email'/>
          <input type='text' placeholder='Password'/>
        </form>
      )
    } else {
      return(
        <form>
          <h1>Sign Up</h1>
          <input type='text' placeholder='Name'/>
          <input type='text' placeholder='Email'/>
          <input type='text' placeholder='Password'/>
          <input type='text' placeholder='Password Confirmation'/>
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