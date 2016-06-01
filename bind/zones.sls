{% for zone in salt['pillar.get']('bind:zones', {}) %}
/etc/bind/db.{{ zone }}:
  file.managed:
    - source: salt://bind/files/zonefile
    - template: jinja
    - user: root
    - group: bind
    - mode: 644
  cmd.run:
    - name: named-checkzone {{ zone }} /etc/bind/db.{{ zone }}
    - require:
        - file: /etc/bind/db.{{ zone }}
{% endfor %}

bind_reload:
  service.running:
    - name: bind9
    - watch:
{% for zone in salt['pillar.get']('bind:zones', {}) %}
        - cmd: /etc/bind/db.{{ zone }}
{% endfor %}
