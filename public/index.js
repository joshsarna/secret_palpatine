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

var UserShowPage = {
  template: "#profile",
  data: function() {
    return {
      user: {}
    };
  },
  created: function() {
    const userId = localStorage.getItem('userId');
    if (!userId) {  
      router.push('/logout');
    }
    axios.get('/api/users/' + userId).then((response) => {
      this.user = response.data;
    });
  },
  methods: {
  }
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
        players: [],
      },
      nextThreePolicies: null,
      someoneElse: {},
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
    start: function() {
      axios.patch('/api/games/' + this.game.id + '/start').then((response) => {
        this.game = response.data;
      });
    },
    appointChancellor: function(playerId) {
      const params = {chancellor_id: playerId};
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    discardSeparatistCard: function() {
      const params = {
        current_hand_separatist_policy_count: this.game.current_hand_separatist_policy_count - 1,
        next_executive_action: this.board.separatistPolicyPowers[this.game.enacted_separatist_policy_count + 1]
      };
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    discardRepublicCard: function() {
      const params = {
        current_hand_republic_policy_count: this.game.current_hand_republic_policy_count - 1,
        next_executive_action: this.board.separatistPolicyPowers[this.game.enacted_separatist_policy_count + 1]
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
    },
    kill: function(playerId) {
      axios.patch('/api/players/' + playerId, {is_dead: true});
    },
    peak: function() {
      axios.get('/api/games/' + this.game.id + '/peak').then((response) => {
        this.nextThreePolicies = response.data.next_three_policies;
        setInterval(() => {
          this.nextThreePolicies = null;
        }, 15000);
      });
    },
    getIdentity: function(playerId) {
      axios.get('/api/players/' + playerId).then((response) => {
        this.someoneElse = response.data;
        setInterval(() => {
          this.someoneElse = {};
        }, 15000);
      });
    },
    appointNextQueen: function(playerId) {
      const indexOfCurrentQueen = this.game.players.indexOf(
        this.game.players.filter(
          (player) => player.id === this.game.queen_id
        )
      );
      const params = {
        queen_id: playerId,
        chancellor_id: null,
        appointed_chancellor_id: null,
        next_queen: this.game.players[indexOfCurrentQueen === this.game.length ? 0 : indexOfCurrentQueen + 1].id,
      };
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    veto: function() {
      const params = {
        next_executive_action: 'veto'
      };
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    },
    queenVeto: function(approved) {
      const params = {
        next_executive_action: null,
        current_hand_republic_policy_count: approved ? 0 : this.game.current_hand_republic_policy_count,
        current_hand_separatist_policy_count: approved ? 0 : this.game.current_hand_separatist_policy_count,
      };
      axios.patch('/api/games/' + this.game.id, params).then((response) => {
        this.game = response.data;
      });
    }
  },

  computed: {
    board: function() {
      return boards[this.game.players.length] || boards[5];
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
    localStorage.removeItem("userId");
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
          localStorage.setItem("userId", response.data.user_id);
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
    { path: "/games/:id", component: GameShowPage },
    { path: "/profile", component: UserShowPage }
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