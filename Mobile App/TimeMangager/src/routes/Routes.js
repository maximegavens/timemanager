import React from 'react';
import {createSwitchNavigator, createAppContainer} from 'react-navigation';
import Icon from 'react-native-vector-icons/Ionicons';
import {createStackNavigator} from 'react-navigation-stack';
import {createBottomTabNavigator} from 'react-navigation-tabs';
import AuthLoadingScreen from '../screens/AuthLoadingScreen';
import HomeScreen from '../screens/app/HomeScreen';
import SignInScreen from '../screens/auth/SignInScreen';
import ResumeScreen from '../screens/app/ResumeScreen';

const HomeStack = createStackNavigator(
  {
    Matchs: {screen: HomeScreen},
    Resume: {screen: ResumeScreen},
  },
  {
    defaultNavigationOptions: ({navigation}) => {
      return {
        headerStyle: {backgroundColor: '#191919'},
      };
    },
  },
);

const DashboardTabNavigator = createBottomTabNavigator(
  {
    Matchs: {
      screen: HomeStack,
      navigationOptions: {
        tabBarIcon: ({tintColor}) => (
          <Icon name="ios-football" size={30} color={tintColor} />
        ),
      },
    },
  },
  {
    tabBarOptions: {
      activeTintColor: '#D4AF37',
      inactiveTintColor: 'gray',
      style: {
        backgroundColor: 'white',
      },
    },
  },
);

const AuthStack = createStackNavigator({SignIn: SignInScreen});

const Routes = createAppContainer(
  createSwitchNavigator(
    {
      AuthLoading: AuthLoadingScreen,
      App: DashboardTabNavigator,
      Auth: AuthStack,
    },
    {
      initialRouteName: 'AuthLoading',
    },
  ),
);

export default Routes;
