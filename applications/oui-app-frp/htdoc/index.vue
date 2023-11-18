<template>
	<n-modal v-model:show="model" preset="dialog" :title="modify ? $t('Change') : $t('Add user')"
		:positive-text="$t('OK')"
		:negative-text="$t('Cancel')"
		@positive-click="addrules">
		<n-form ref="form" :model="tableValue" :rules="rules" label-placement="left" label-width="auto">
			<n-form-item :label="$t('Servername')" path="remark">
				<n-input v-model:value="tableValue.remark"/>
			</n-form-item>
			<n-form-item :label="$t('Type')" path="type">
				<n-input v-model:value="tableValue.type"/>
			</n-form-item>
			<n-form-item :label="$t('Domain')" path="domain">
				<n-input v-model:value="tableValue.domain"/>
			</n-form-item>
			<n-form-item :label="$t('RemotePort')" path="rport">
				<n-input v-model:value="tableValue.rport"/>
			</n-form-item>
			<n-form-item :label="$t('Addr')" path="deviceIP">
				<n-input v-model:value="tableValue.deviceIP"/>
			</n-form-item>
			<n-form-item :label="$t('nPort')" path="nport">
				<n-input v-model:value="tableValue.nport"/>
			</n-form-item>
		</n-form>
	</n-modal>

	<br>
	<!--使能框-->
	<n-space justify="start" style="padding-left: 150px">
		<n-checkbox v-model:checked="keepEnable">{{ $t('Enable') }}</n-checkbox>
	</n-space>
	<br>

	<n-form size="large" ref="form" label-placement="left" label-width="auto" :model="formValue">

		<n-form-item :label="$t('IP')" path="server">
			<n-input v-model:value="formValue.server" style="width: 200px"/>
		</n-form-item>

		<n-form-item :label="$t('Port')" path="port">
			<n-input v-model:value="formValue.port" style="width: 200px"/>
		</n-form-item>

		<n-form-item :label="$t('Token')" path="token">
			<n-input v-model:value="formValue.token" style="width: 200px"/>
		</n-form-item>

		<n-form-item :label="$t('Time')" path="time">
			<n-input v-model:value="formValue.time" style="width: 200px"/>
		</n-form-item>
	</n-form>

	<n-divider/><!--分割线-->

	<!--数据表-->
	<n-data-table :row-key="r => r.id" :columns="columns" :data="users"/>
	<br>
	<n-space justify="end" style="padding-right: 100px">
		<n-button type="primary"  @click="showAdd">{{ $t('add') }}</n-button>
		<n-button type="primary"  @click="saveconfig">{{ $t('save') }}</n-button>
	</n-space>
</template>

<script>
import { h, resolveComponent } from 'vue'

export default {
  data() {
    return {
      model: false,
      modify: '',
      users: [],
      keepEnable: false,
      formValue: {
        server: '', //服务器地址
        port: '', //服务端口
        token: '', //令牌
        time: '' //服务注册间隔
      },
      tableValue: {
        remark: '', //服务名称
        type: '', //协议类型
        domain: '', //域名
        rport: '', //远程端口
        deviceIP: '', //内网IP
        nport: '' //内网端口
      },
      columns: [
        {
          title: () => this.$t('Servername'),
          key: 'servername'
        },
        {
          title: () => this.$t('Type'),
          key: 'type'
        },
        {
          title: () => this.$t('Domain'),
          key: 'domain'
        },
        {
          title: () => this.$t('RemotePort'),
          key: 'remoteport'
        },
        {
          title: () => this.$t('Addr'),
          key: 'addr'
        },
        {
          title: () => this.$t('Port'),
          key: 'port'
        },
        {
          key: 'actions',
          render: r => h(resolveComponent('n-space'), () => [
            h(resolveComponent('n-button'), { type: 'primary', onClick: () => this.modifyrules(r) }, () => this.$t('Change')),
            h(resolveComponent('n-button'), { type: 'error', onClick: () => this.deleterules(r) }, () => this.$t('Delete'))
          ])
        }],
      rules: {
        remark: {
          required: true,
          trigger: 'blur',
          message: () => this.$t('message1')
        },
        type: {
          required: true,
          trigger: 'blur',
          message: () => this.$t('message2')
        },
        domain: {
          required: true,
          trigger: 'blur',
          message: () => this.$t('message3')
        },
        rport: {
          required: true,
          trigger: 'blur',
          message: () => this.$t('message4')
        },
        deviceIP: {
          required: true,
          trigger: 'blur',
          message: () => this.$t('message5')
        },
        nport: {
          required: true,
          trigger: 'blur',
          message: () => this.$t('message5')
        }
      }
    }
  },


  methods: {
    //添加规则空白项
    showAdd() {
      this.modify = ''
      this.tableValue.remark = ''
      this.tableValue.type = ''
      this.tableValue.domain = ''
      this.tableValue.rport = ''
      this.tableValue.deviceIP = ''
      this.tableValue.nport = ''
      this.model = true
    },

    //获取规则-err
    getrules() {
      this.$oui.call('frp', 'get_rules').then(({ users }) => {
        this.users = users
      })
    },

    //修改规则
    modifyrules(r) {
      this.modify = r.id
      this.tableValue.remark = r.servername
      this.tableValue.type = r.type
      this.tableValue.domain = r.domain
      this.tableValue.rport = r.remoteport
      this.tableValue.deviceIP = r.addr
      this.tableValue.nport = r.port
      this.model = true
    },

    //删除规则
    deleterules(user) {
      this.$dialog.create({
        content: this.$t('delete-user-confirm', { remark: user.servername }),
        negativeText: this.$t('Cancel'),
        positiveText: this.$t('OK'),
        onPositiveClick: () => {
          this.$oui.call('frp', 'delete_rules', { id: user.id }).then(() => this.getrules())
        }
      })
    },

    //载入列表信息
    addrules() {
      return new Promise((resolve, reject) => {
        this.$refs.form.validate(errors => {
          if (errors) {
            reject()
            return
          }

          //修改一条规则
          if (this.modify) {
            this.$oui.call('frp', 'change_rules', {
              remark: this.tableValue.remark,
              mytype: this.tableValue.type,
              local_ip: this.tableValue.deviceIP,
              local_port: this.tableValue.nport,
              custom_domains: this.tableValue.domain,
              remote_port: this.tableValue.rport,
              id: this.modify
            })

            resolve()
            this.getrules()
          } else {//添加一条规则
            this.$oui.call('frp', 'add_rules', {
              remark: this.tableValue.remark,
              mytype: this.tableValue.type,
              local_ip: this.tableValue.deviceIP,
              local_port: this.tableValue.nport,
              custom_domains: this.tableValue.domain,
              remote_port: this.tableValue.rport
            }).then(({ code }) => {

              if (code === 0) {
                resolve()
                this.getrules()
              } else {
                reject()
                this.$message.error(this.$t('username-exist', { remark: this.tableValue.remark }))
              }
            })
          }
        })
      })
    },

    //将数据保存到config文件,并调用启动脚本
    saveconfig() {
      //this.$refs.form.validate(async errors => {
      //if (errors)
      //	return

      this.$oui.call('frp', 'start', {
        enable: this.keepEnable,
        server: this.formValue.server,
        port: this.formValue.port,
        time: this.formValue.time,
        token: this.formValue.token
      })



      //await this.$oui.call('frp','enable').then(()=>{})//执行frp启动脚本
      //this.$oui.call('frp','enable').then(()=>{})//执行frp启动脚本

      this.$message.success(this.$t('Configuration has been applied'))
      //})
    }
  },
  created() {
    this.getrules()//获取规则列表
    this.$oui.ubus('uci', 'get', {'config':'frp', 'section':'common'}).then(r => {
      this.formValue.server = r.values.server_addr
      this.formValue.port = r.values.server_port
      this.formValue.token = r.values.token
      this.formValue.time = r.values.time
      if (r.values.enabled === '1') {
        this.keepEnable = true
      } else {
        this.keepEnable = false
      }

    })

  }

}

</script>

<style>
      th {
			text-align: center;/* 设置水平方向居中 */
			vertical-align: middle/* 设置垂直方向居中 */
         }
</style>


<i18n src="./locale.json"/>
