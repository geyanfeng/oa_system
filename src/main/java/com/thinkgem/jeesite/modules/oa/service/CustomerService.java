/**
 * 
 */
package com.thinkgem.jeesite.modules.oa.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.modules.oa.entity.Customer;
import com.thinkgem.jeesite.modules.oa.dao.CustomerDao;

/**
 * 客户信息Service
 * @author anthony
 * @version 2016-07-17
 */
@Service
@Transactional(readOnly = true)
public class CustomerService extends CrudService<CustomerDao, Customer> {
	@Autowired
	private CustomerDao customerDao;

	public Customer get(String id) {
		return super.get(id);
	}
	
	public List<Customer> findList(Customer customer) {
		return super.findList(customer);
	}
	
	public Page<Customer> findPage(Page<Customer> page, Customer customer) {
		return super.findPage(page, customer);
	}
	
	@Transactional(readOnly = false)
	public void save(Customer customer) {
		super.save(customer);
	}
	
	@Transactional(readOnly = false)
	public void delete(Customer customer) {
		super.delete(customer);
	}

	public Customer getCustomerByName(String name) {
		return customerDao.getCustomerByName(name);
	}

	@Transactional(readOnly = false)
	public void changeUsedFlag(Customer customer) {
		customerDao.changeUsedFlag(customer);
	}

	public Customer getCustomerByAddress(String address) {
		return customerDao.getCustomerByAddress(address);
	}

	public Customer getCustomerByPhone(String phone) {
		return customerDao.getCustomerByPhone(phone);
	}
}