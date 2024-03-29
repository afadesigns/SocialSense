(function ($) {
  class Sharrre {
    constructor(element, options) {
      this.element = element;
      this.options = Object.assign({}, this.defaults, options);
      this.options.share = Object.assign({}, this.defaults.share, options.share);
      this.buttons = {};
      this.count = {};
      this.total = 0;
      this.init();
    }

    get defaults() {
      return {
        className: 'sharrre',
        share: {
          googlePlus: false,
          facebook: false,
          twitter: false,
          digg: false,
          delicious: false,
          stumbleupon: false,
          linkedin: false,
          pinterest: false,
        },
        shareTotal: 0,
        template: '',
        title: '',
        url: document.location.href,
        text: document.title,
        urlCurl: 'sharrre.php',
        counter: {},
        total: 0,
        shorterTotal: true,
        enableHover: true,
        enableCounter: true,
        enableTracking: false,
        hover: () => {},
        hide: () => {},
        click: () => {},
        render: () => {},
        buttons: {
          googlePlus: {
            url: '',
            urlCount: false,
            size: 'medium',
            lang: 'en-US',
            annotation: '',
          },
          facebook: {
            url: '',
            urlCount: false,
            action: 'like',
            layout: 'button_count',
            width: '',
            send: 'false',
            faces: 'false',
            colorscheme: '',
            font: '',
            lang: 'en_US',
          },
          twitter: {
            url: '',
            urlCount: false,
            count: 'horizontal',
            hashtags: '',
            via: '',
            related: '',
            lang: 'en',
          },
          digg: {
            url: '',
            urlCount: false,
            type: 'DiggCompact',
          },
          delicious: {
            url: '',
            urlCount: false,
            size: 'medium',
          },
          stumbleupon: {
            url: '',
            urlCount: false,
            layout: '1',
          },
          linkedin: {
            url: '',
            urlCount: false,
            counter: '',
          },
          pinterest: {
            url: '',
            media: '',
            description: '',
            layout: 'horizontal',
          },
        },
      };
    }

    init() {
      if (this.options.urlCurl !== '') {
        this.urlJson.googlePlus = `${this.options.urlCurl}?url={url}&type=googlePlus`;
        this.urlJson.stumbleupon = `${this.options.urlCurl}?url={url}&type=stumbleupon`;
      }
      $(this.element).addClass(this.options.className);
      if (typeof $(this.element).data('title') !== 'undefined') {
        this.options.title = $(this.element).attr('data-title');
      }
      if (typeof $(this.element).data('url') !== 'undefined') {
        this.options.url = $(this.element).data('url');
      }
      if (typeof $(this.element).data('text') !== 'undefined') {
        this.options.text = $(this.element).data('text');
      }
      this.options.shareTotal = Object.values(this.options.share).filter(Boolean).length;
      if (this.options.enableCounter) {
        this.getCount();
      } else if (this.options.template !== '') {
        this.options.render(this, this.options);
      } else {
        this.loadButtons();
      }
      $(this.element).hover(
        () => {
          if ($(this.element).find('.buttons').length === 0 && this.options.enableHover) {
            this.loadButtons();
          }
          this.options.hover(this, this.options);
        },
        () => {
          this.options.hide(this, this.options);
        }
      );
      $(this.element).click((event) => {
        event.preventDefault();
        this.options.click(this, this.options);
      });
    }

    loadButtons() {
      $(this.element).append('<div class="buttons"></div>');
      Object.entries(this.options.share).forEach(([name, val]) => {
        if (val) {
          this.buttons[name] = document.createElement('div');
          this.buttons[name].className = `button ${name}`;
          $(this.element).find('.buttons').append(this.buttons[name]);
          this.loadButton(name);
          if (this.options.enableTracking) {
            this.tracking[name]();
          }
        }
      });
    }

    async loadButton(name) {
      const button = this.buttons[name];
     
