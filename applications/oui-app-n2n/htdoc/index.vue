<template>
  <n-modal v-model:show="model" preset="dialog" :title="modify ? $t('Change') : $t('add')"
		:positive-text="$t('OK')"
		:negative-text="$t('Cancel')"
		@positive-click="addroute">
		<n-form ref="form" :model="tableValue" :rules="rules" label-placement="left" label-width="auto">
			<n-form-item :label="$t('IP')" path="ip">
				<n-input v-model:value="tableValue.ip"/>
			</n-form-item>
			<n-form-item :label="$t('mask1')" path="mask">
        <n-select v-model:value="tableValue.mask" :options="option1" />
			</n-form-item>
			<n-form-item :label="$t('gateway')" path="gateway">
				<n-input v-model:value="tableValue.gateway"/>
			</n-form-item>
			<n-form-item :label="$t('description')" path="description">
				<n-input v-model:value="tableValue.description"/>
			</n-form-item>
		</n-form>
	</n-modal>
  <br>
	<!--使能框-->
	<n-space justify="start" style="padding-left: 200px">
		<n-checkbox v-model:checked="keepEnable">{{ $t('Enable') }}</n-checkbox>
	</n-space>
	<br>

  <n-form size="large" ref="form" label-placement="left" label-width="200px" :model="formValue">
		<n-form-item :label="$t('name')" path="name">
			<n-input v-model:value="formValue.name" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('mode')" path="mode">
      <n-select v-model:value="formValue.mode" :options="option" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('dynamicIP')" path="DynamicIP" v-if="formValue.mode=='dhcp'">
			<n-input v-model:value="formValue.DynamicIP" style="width: 200px" placeholder="" disabled/>
		</n-form-item>
    <n-form-item :label="$t('staticIP')" path="staticIP" v-if="formValue.mode=='static'">
			<n-input v-model:value="formValue.staticIP" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('mask')" path="mask" v-if="formValue.mode=='static'">
			<n-select v-model:value="formValue.mask" :options="option1" style="width: 200px" />
		</n-form-item>
    <n-form-item :label="$t('mtu')" path="mtu">
			<n-input v-model:value="formValue.mtu" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('supernodeIP1')" path="supernodeIP1">
			<n-input v-model:value="formValue.supernodeIP1" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('supernodeP1')" path="supernodeP1">
			<n-input v-model:value="formValue.supernodeP1" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('supernodeIP2')" path="supernodeIP2">
			<n-input v-model:value="formValue.supernodeIP2" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('supernodeP2')" path="supernodeP2">
			<n-input v-model:value="formValue.supernodeP2" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('group')" path="group">
			<n-input v-model:value="formValue.group" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('passwd')" path="passwd">
			<n-input v-model:value="formValue.passwd" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('time')" path="time">
			<n-input v-model:value="formValue.time" style="width: 200px"/>
		</n-form-item>
	</n-form>
  <n-divider title-placement="left">
    {{ $t('route') }}
  </n-divider>
	<!--数据表-->
	<n-data-table :row-key="r => r.id" :columns="columns" :data="users"/>
  <br>
	<n-space justify="end" style="padding-right: 150px">
		<n-button type="primary"  @click="showAdd">{{ $t('add') }}</n-button>
		<n-button type="primary"  @click="saveconfig">{{ $t('save') }}</n-button>
	</n-space>
</template>
<script>
import { h, resolveComponent } from 'vue'
export default {
  data() {
    return {
      columns: [
        {
          title: () => this.$t('IP'),
          key: 'ip'
        },
        {
          title: () => this.$t('mask1'),
          key: 'mask1'
        },
        {
          title: () => this.$t('gateway'),
          key: 'gateway'
        },
        {
          title: () => this.$t('description'),
          key: 'description'
        },
        {
          key: 'actions',
          render: r => h(resolveComponent('n-space'), () => [
            h(resolveComponent('n-button'), { type: 'primary', onClick: () => this.modifyrules(r) }, () => this.$t('Change')),
            h(resolveComponent('n-button'), { type: 'error', onClick: () => this.deleteroute(r) }, () => this.$t('Delete'))
          ])
        }],
      model: false,
      modify: '',
      users: [],
      keepEnable: false,
      formValue: {
        DynamicIP: '',
        name: 'edge',
        mode: 'dhcp',
        staticIP: '192.168.1.1',
        mask: '24(255.255.255.0)',
        mtu: '1290',
        supernodeIP1: '10.10.10.10',
        supernodeP1: '8000',
        supernodeIP2: '11.11.11.11',
        supernodeP2: '8080',
        group: 'lan2lan',
        passwd: '123456',
        time: '40'
      },
      tableValue: {
        ip: '',
        mask: '',
        gateway: '',
        description: ''
      },
      option: [
        {
          label: 'dhcp',
          value: 'dhcp'
        },
        {
          label: 'static',
          value: 'static'
        }
      ],
      option1: [
        {
          label: '8(255.0.0.0)',
          value: '8'
        },
        {
          label: '16(255.255.0.0)',
          value: '16'
        },
        {
          label: '24(255.255.255.0)',
          value: '24'
        },
        {
          label: '28(255.255.255.240)',
          value: '28'
        }
      ]
    }
  },
  methods: {
    showAdd() {
      this.modify = ''
      this.tableValue.ip = ''
      this.tableValue.mask = ''
      this.tableValue.gateway = ''
      this.tableValue.description = ''
      this.model = true
    },

    //获取路由表
    getroute() {
      this.$oui.call('n2n', 'get_route').then(({ users }) => {
        this.users = users
      })
    },
    modifyrules(r) {
      this.modify = r.id
      this.tableValue.ip = r.ip
      this.tableValue.mask = r.mask1
      this.tableValue.gateway = r.gateway
      this.tableValue.description = r.description
      this.model = true
    },
    deleteroute(user) {
      this.$dialog.create({
        content: this.$t('delete-user-confirm', { remark: user.ip }),
        negativeText: this.$t('Cancel'),
        positiveText: this.$t('OK'),
        onPositiveClick: () => {
          this.$oui.call('n2n', 'delete_route', { id: user.id }).then(() => this.getroute())
        }
      })
    },
    addroute() {
      return new Promise((resolve, reject) => {
        this.$refs.form.validate(errors => {
          if (errors) {
            reject()
            return
          }

          //修改一条规则
          if (this.modify) {
            this.$oui.call('n2n', 'change_route', {
              target: this.tableValue.ip,
              mask: this.tableValue.mask,
              gateway: this.tableValue.gateway,
              comment: this.tableValue.description,
              id: this.modify
            })
            resolve()
            this.getroute()
          } else {//添加一条规则
            this.$oui.call('n2n', 'add_route', {
              target: this.tableValue.ip,
              mask: this.tableValue.mask,
              gateway: this.tableValue.gateway,
              comment: this.tableValue.description
            }).then(() => {
              resolve()
              this.getroute()
            })
          }
        })
      })
    }

  },
  created() {
    this.getroute()
    this.$oui.ubus('uci', 'get', {'config':'n2n_v3', 'section':'edge'}).then(r => {
      this.formValue.name = r.values.tunname
      this.formValue.mode = r.values.mode
      this.formValue.staticIP = r.values.ipaddr
      this.formValue.mask = r.values.netmask
      this.formValue.mtu = r.values.mtu
      this.formValue.supernodeIP1 = r.values.supernode
      this.formValue.supernodeP1 = r.values.port
      this.formValue.supernodeIP2 = r.values.second_supernode
      this.formValue.supernodeP2 = r.values.second_port
      this.formValue.group = r.values.community
      this.formValue.passwd = r.values.key
      this.formValue.time = r.values.time_checkip
      if (r.values.enabled === '1') {
        this.keepEnable = true
      } else {
        this.keepEnable = false
      }

    })

  }
}
</script>
<i18n src="./locale.json"/>
