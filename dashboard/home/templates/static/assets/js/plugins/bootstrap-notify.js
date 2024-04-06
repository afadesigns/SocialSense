import $ from 'jquery';
import 'bootstrap';
import defaults from './defaults';

const isDuplicateNotification = (notification: Notify) => {
  // ...
};

class Notify {
  // ...
}

$.notify = (content: NotifyContent, options?: NotifyOptions) => {
  // ...
};

$.notifyDefaults = (options: NotifyOptions) => {
  // ...
};

$.notifyClose = (selector?: string) => {
  // ...
};

$.notifyCloseExcept = (selector?: string) => {
  // ...
};

export default $;


export default {
  element: 'body',
  position: null,
  type: 'info',
  allow_dismiss: true,
  allow_duplicates: true,
  newest_on_top: false,
  showProgressbar: false,
  placement: {
    from: 'top',
    align: 'right'
  },
  offset: 20,
  spacing: 10,
  z_index: 1060,
  delay: 5000,
  timer: 1000,
  url_target: '_blank',
  mouse_over: null,
  animate: {
    enter: 'animated fadeInDown',
    exit: 'animated fadeOutUp'
  },
  onShow: null,
  onShown: null,
  onClose: null,
  onClosed: null,
  onClick: null,
  icon_type: 'class',
  template: '<div data-notify="container" class="col-11 col-md-4 alert alert-{0}" role="alert"><button type="button" aria-hidden="true" class="close" data-notify="dismiss"><i class="tim-icons icon-simple-remove"></i></button><span data-notify="icon"></span> <span data-notify="title">{1}</span> <span data-notify="message">{2}</span><div class="progress" data-notify="progressbar"><div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div></div><a href="{3}" target="{4}" data-notify="url"></a></div>'
};


{
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true
  }
}


{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/eslint-recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "plugins": ["@typescript-eslint"],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 2018,
    "sourceType": "module"
  },
  "rules": {
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": "error",
    "no-multiple-empty-lines": "error",
    "no-trailing-spaces": "error",
    "quotes": ["error", "double"],
    "semi": "error"
  }
}
