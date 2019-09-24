import React, {Component} from 'react';
import {
  View,
  Text,
  ImageBackground,
  StyleSheet,
  Image,
  TextInput,
  Dimensions,
  TouchableOpacity,
  AsyncStorage,
} from 'react-native';
import axios from 'axios';
import BgImage from '../../../assets/Gotham_city.png';
import Logo from '../../../assets/logo.png';
import Icon from 'react-native-vector-icons/Ionicons';

const {width: WIDTH} = Dimensions.get('window');

class SignInScreen extends Component {
  static navigationOptions = {
    header: null,
  };
  constructor(props) {
    super(props);
    this.state = {
      showPass: true,
      press: false,
      email: undefined,
      password: undefined,
    };
  }
  showPass = () => {
    if (this.state.press == false) {
      this.setState({showPass: false, press: true});
    } else {
      this.setState({showPass: true, press: false});
    }
  };

  handleLogin = async () => {
    axios
      .post('https://sport-analytica.com/api/login', {
        email: this.state.email,
        password: this.state.password,
      })
      .then(res => {
        console.log(res.data);
        AsyncStorage.setItem('token', res.data.token);
        this.props.navigation.navigate('App');
      })
      .catch(err => console.log(err));
  };

  render() {
    return (
      <ImageBackground source={BgImage} style={styles.backgroundContainer}>
        <View style={styles.logoContainer}>
          <Image source={Logo} style={styles.logo} />
          <Text style={styles.logoText}>Sport Analytica</Text>
        </View>
        <View style={styles.inputContainer}>
          <Icon
            name={'ios-person'}
            size={28}
            style={styles.inputIcon}
            color={'rgba(255,255,255,0.7)'}
          />
          <TextInput
            autoCapitalize={'none'}
            style={styles.input}
            placeholder={'Email'}
            placeholderTextColor={'rgba(255,255,255, 0.7)'}
            underlineColorAndroid="transparent"
            onChangeText={email => this.setState({email})}
            value={this.state.email}
          />
        </View>
        <View style={styles.inputContainer}>
          <Icon
            name={'ios-lock'}
            size={28}
            style={styles.inputIcon}
            color={'rgba(255,255,255,0.7)'}
          />
          <TextInput
            style={styles.input}
            placeholder={'Password'}
            placeholderTextColor={'rgba(255,255,255, 0.7)'}
            underlineColorAndroid="transparent"
            secureTextEntry={this.state.showPass}
            onChangeText={password => this.setState({password})}
            value={this.state.password}
          />
          <TouchableOpacity
            style={styles.btnEye}
            onPress={this.showPass.bind(this)}>
            <Icon
              name={this.state.press == false ? 'ios-eye' : 'ios-eye-off'}
              size={26}
              color={'rgba(255,255,255,0.7)'}
            />
          </TouchableOpacity>
        </View>
        <TouchableOpacity
          style={styles.btnLogin}
          onPress={this.handleLogin.bind(this)}>
          <Text style={styles.text}>Login</Text>
        </TouchableOpacity>
      </ImageBackground>
    );
  }
}

const styles = StyleSheet.create({
  backgroundContainer: {
    flex: 1,
    width: null,
    height: null,
    justifyContent: 'center',
    alignItems: 'center',
  },
  logoContainer: {
    alignItems: 'center',
    marginBottom: 50,
  },
  logo: {
    height: 135,
    width: 120,
  },
  logoText: {
    color: '#FFC107',
    fontSize: 25,
    fontWeight: '500',
    margin: 10,
    opacity: 0.8,
    textTransform: 'uppercase',
  },
  inputContainer: {
    marginTop: 10,
  },
  input: {
    width: WIDTH - 55,
    height: 45,
    borderRadius: 25,
    fontSize: 16,
    paddingLeft: 40,
    backgroundColor: 'rgba(0,0,0, 0.35)',
    color: 'rgba(255,255,255, 1)',
    marginHorizontal: 25,
  },
  inputIcon: {
    position: 'absolute',
    top: 8,
    left: 37,
  },
  btnEye: {
    position: 'absolute',
    top: 8,
    right: 37,
  },
  btnLogin: {
    width: WIDTH - 55,
    height: 45,
    borderRadius: 25,
    justifyContent: 'center',
    marginTop: 20,
    backgroundColor: '#FFC107',
    opacity: 0.8,
  },
  text: {
    color: 'black',
    fontSize: 16,
    textAlign: 'center',
  },
});

export default SignInScreen;
