/* global Vue, VueRouter, axios */

const boards = {
  5: {
    republicPoliciesRequired: 5,
    separatistPoliciesRequired: 6,
    separatistPolicyPowers: [
      null,
      null,
      null,
      'muchToLearn',
      'order66',
      'order66',
    ]
  },
  6: {
    republicPoliciesRequired: 5,
    separatistPoliciesRequired: 6,
    separatistPolicyPowers: [
      null,
      null,
      null,
      'muchToLearn',
      'order66',
      'order66'
    ]
  },
  7: {
    republicPoliciesRequired: 5,
    separatistPoliciesRequired: 6,
    separatistPolicyPowers: [
      null,
      null,
      'helloThere',
      'iAmTheSenate',
      'order66',
      'order66'
    ]
  },
  8: {
    republicPoliciesRequired: 5,
    separatistPoliciesRequired: 6,
    separatistPolicyPowers: [
      null,
      null,
      'helloThere',
      'iAmTheSenate',
      'order66',
      'order66'
    ]
  },
  9: {
    republicPoliciesRequired: 5,
    separatistPoliciesRequired: 6,
    separatistPolicyPowers: [
      null,
      'helloThere',
      'helloThere',
      'iAmTheSenate',
      'order66',
      'order66',
    ]
  },
  10: {
    republicPoliciesRequired: 5,
    separatistPoliciesRequired: 6,
    separatistPolicyPowers: [
      null,
      'helloThere',
      'helloThere',
      'iAmTheSenate',
      'order66',
      'order66'
    ]
  },
};

var GameShowPage = {
  template: "#game-show-page",
  data: function() {
    return {
      game: {
        id: '',
        has_started: false,
        queen_id: '',
        chancellor_id: '',
        appointed_chancellor_id: '',
        enacted_republic_policy_count: 0,
        enacted_separatist_policy_count: 0,
        turn_number: 0,
        current_hand_republic_policy_count: 0,
        current_hand_separatist_policy_count: 0,
      },
      canSteal: false,
      pollId: null
    };
  },

  created: function() {
    let jwt = localStorage.getItem('jwt');
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    } else {
      router.push('/signup');
    }

    axios.get('/api/games/' + this.$route.params.id).then((response) => {
      this.game = response.data;
    });

    this.pollId = setInterval(() => {
      axios.get('/api/games/' + this.game.id).then((response) => {
        this.game = response.data;
      });
    }, 1000);
  },

  beforeDestroy: function() {
    clearInterval(this.pollId);
  },

  methods: {
    appointChancellor: function(playerId) {
      const params = {chancellor_id: playerId};
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    discardSeparatistCard: function() {
      const params = {
        current_hand_separatist_policy_count: this.game.current_hand_separatist_policy_count - 1
      };
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    discardRepublicCard: function() {
      const params = {
        current_hand_republic_policy_count: this.game.current_hand_republic_policy_count - 1
      };
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    vote: function(vote) {
      const params = {
        game_id: this.game.id,
        in_favor: vote
      };
      axios.patch('/api/votes', params).then((response) => {
        this.game = response.data;
      });
    }
  },

  computed: {
    board: function() {
      // const boards = require('./boards.js').boards;
      // return boards[this.game.players.length()];
      return boards[5];
    },
    enactedSeparatistPolicies: function() {
      return Array(this.game.enacted_separatist_policy_count);
    },
    enactedRepublicPolicies: function() {
      return Array(this.game.enacted_republic_policy_count);
    },
    emptySeparatistPolicies: function() {
      return Array(this.board.separatistPoliciesRequired - this.game.enacted_separatist_policy_count);
    },
    emptyRepublicPolicies: function() {
      return Array(this.board.republicPoliciesRequired - this.game.enacted_republic_policy_count);
    },
  }
};

var LogoutPage = {
  template: "<h1>Logout</h1>",
  created: function() {
    axios.defaults.headers.common["Authorization"] = undefined;
    localStorage.removeItem("jwt");
    router.push("/");
  }
};

var LoginPage = {
  template: "#login-page",
  data: function() {
    return {
      email: "",
      password: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        email: this.email, password: this.password
      };
      axios
        .post("/api/sessions", params)
        .then(function(response) {
          axios.defaults.headers.common["Authorization"] =
            "Bearer " + response.data.jwt;
          localStorage.setItem("jwt", response.data.jwt);
          router.push("/");
        })
        .catch(
          function(error) {
            this.errors = ["Invalid email or password."];
            this.email = "";
            this.password = "";
          }.bind(this)
        );
    }
  }
};

var SignupPage = {
  template: "#signup-page",
  data: function() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      };
      axios
        .post("/api/users", params)
        .then(function(response) {
          router.push("/login");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      gameToJoin: ''
    };
  },
  created: function() {
    let jwt = localStorage.getItem('jwt');
    if (jwt && jwt !== 'undefined') {
      axios.defaults.headers.common["Authorization"] = jwt;
    } else {
      router.push('/signup');
    }
  },
  methods: {
    createGame: () => {
      axios.post('/api/games',
        {}
      ).then((response) => {
        localStorage.setItem('canSteal', 'false');
        router.push('/games/' + response.data.id);
      });
    },

    joinGame: function() {
      axios.post('/api/players',
        { game_id: this.gameToJoin }
      ).then((response) => {
        router.push('/games/' + this.gameToJoin);
      });
    }
  },
  computed: {}
};

var router = new VueRouter({
  routes: [
    { path: "/", component: HomePage },
    { path: "/signup", component: SignupPage },
    { path: "/login", component: LoginPage },
    { path: "/logout", component: LogoutPage },
    { path: "/games/:id", component: GameShowPage }
  ],
  scrollBehavior: function(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#vue-app",
  router: router,
  created: function() {
    var jwt = localStorage.getItem("jwt");
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    }
  }
});